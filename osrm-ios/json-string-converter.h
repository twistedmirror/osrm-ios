#ifndef JSON_STRING_CONVERTER_HPP
#define JSON_STRING_CONVERTER_HPP

#include <osrm/json_container.hpp>

namespace osrm
{
    namespace util
    {
        namespace json
        {

            namespace detail {
                std::string double_fixed_to_string(const double value)
                {
                    std::string output = std::to_string(value);
                    if (output.size() >= 2 && output[output.size() - 2] == '.' &&
                        output[output.size() - 1] == '0')
                    {
                        output.resize(output.size() - 2);
                    }
                    return output;
                }

            }

            template<class output_container>
            struct JSONVisitor {

            private:
                output_container &out;

                static inline void ReplaceAll(std::string& str, const std::string& from, const std::string& to) {
                    size_t start_pos = 0;
                    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
                        str.replace(start_pos, from.length(), to);
                        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
                    }
                }
                
            public:
                explicit JSONVisitor(output_container &_out) : out(_out) {}

                void operator()(const String &string) const
                {
                    out.push_back('"');
                    
                    std::string s(string.value);
                    
                    ReplaceAll(s, "\\", "\\\\");
                    ReplaceAll(s, "\"", "\\\"");
                    
                    out.insert(out.end(), s.begin(), s.end());
                    out.push_back('"');
                }

                void operator()(const Number &number) const
                {
                    const std::string number_string = detail::double_fixed_to_string(number.value);
                    out.insert(out.end(), number_string.begin(), number_string.end());
                }

                void operator()(const Object &object) const
                {
                    out.push_back('{');
                    auto iterator = object.values.begin();
                    while (iterator != object.values.end())
                    {
                        out.push_back('"');
                        out.insert(out.end(), (*iterator).first.begin(), (*iterator).first.end());
                        out.push_back('"');
                        out.push_back(':');

                        mapbox::util::apply_visitor(JSONVisitor(out), (*iterator).second);
                        if (++iterator != object.values.end())
                        {
                            out.push_back(',');
                        }
                    }
                    out.push_back('}');
                }

                void operator()(const Array &array) const
                {
                    out.push_back('[');
                    std::vector<Value>::const_iterator iterator;
                    iterator = array.values.begin();
                    while (iterator != array.values.end())
                    {
                        mapbox::util::apply_visitor(JSONVisitor(out), *iterator);
                        if (++iterator != array.values.end())
                        {
                            out.push_back(',');
                        }
                    }
                    out.push_back(']');
                }

                void operator()(const True &) const
                {
                    const std::string temp("true");
                    out.insert(out.end(), temp.begin(), temp.end());
                }

                void operator()(const False &) const
                {
                    const std::string temp("false");
                    out.insert(out.end(), temp.begin(), temp.end());
                }

                void operator()(const Null &) const
                {
                    const std::string temp("null");
                    out.insert(out.end(), temp.begin(), temp.end());
                }
            };

            template<class output_container>
            void convert(output_container &out, const Object &object)
            {
                Value value = object;
                mapbox::util::apply_visitor(JSONVisitor<output_container>(out), value);
            }
        } // namespace json
    } // namespace util
} // namespace osrm
#endif // JSON_STRING_CONVERTER_HPP
