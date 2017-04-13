start: _NL* composite _NL*

composite: composite_type attr? _NL+ composite_body _END
       | composite_type points _END
       | composite_type pattern _END
       | composite_type attr _END

composite_body: _composite_item*
_composite_item: (composite|attr|points|projection|metadata|pattern|validation|values) _NL+

points: "POINTS" _NL* (_num_pair _NL*)* _END
pattern: "PATTERN" _NL* (_num_pair _NL*)* _END

projection: "PROJECTION" _NL+ ((string _NL*)+|"AUTO"i _NL+) _END
metadata: "METADATA" _NL+ ((string_pair|attr) _NL+)+ _END
values: "VALUES" _NL+ ((string_pair) _NL+)+ _END
validation: "VALIDATION" _NL+ ((string_pair|attr) _NL+)+ _END


attr: attr_name value+

attr_name: NAME | composite_type
?value: bare_string | string | int | float | expression | attr_bind | path | regexp | runtime_var | list

int: SIGNED_INT
int_pair: int int
!bare_string: NAME | "SYMBOL"i | "AUTO"i | "GRID"i | "CLASS"i
string: STRING1 | STRING2 | STRING3 
string_pair: string string
float: SIGNED_FLOAT
float_pair: float float
path: PATH
regexp: REGEXP
runtime_var: RUNTIME_VAR
list: "{" value ("," value)* "}"

_num_pair: (int|float) _NL* (int|float)

attr_bind: "[" bare_string "]"

?expression: "(" or_test ")"
?or_test : (or_test "OR")? and_test
?and_test : (and_test "AND")? comparison
?comparison: (comparison compare_op)? add
!compare_op: ">=" | "<" | "=*" | "==" | "=" | "~" | "~*" | ">" | "<=" | "IN"

?add: (add "+")? (func_call | value)
func_call: attr_name "(" func_params ")"
func_params: value ("," value)*

!composite_type: "CLASS"i
            | "CLUSTER"i
            | "COMPOSITE"i
            | "CONFIG"i
            | "FEATURE"i
            | "FONTSET"i
            | "GRID"i
            | "INCLUDE"i
            | "JOIN"i
            | "LABEL"i
            | "LAYER"i
            | "LEADER"i
            | "LEGEND"i
            | "MAP"i
            | "OUTPUTFORMAT"i
            | "QUERYMAP"i
            | "REFERENCE"i
            | "SCALEBAR"i
            | "SCALETOKEN"i
            | "STYLE"i
            | "SYMBOL"i
            | "WEB"i

PATH: /[a-z_]*[.\/][a-z0-9_\/.]+/i
NAME: /[a-z_][a-z0-9_]*/i

SIGNED_FLOAT: ["-"|"+"] FLOAT
SIGNED_INT: ["-"|"+"] INT

%import common.FLOAT
%import common.INT

STRING1: /".*?(?<!\\\\)(\\\\\\\\)*?"/
STRING2: /'.*?(?<!\\\\)(\\\\\\\\)*?'/
STRING3: /`.*?`/   // XXX TODO
REGEXP: /\/.*?\//
RUNTIME_VAR: /%.*?%/

COMMENT: /\#[^\n]*/
CCOMMENT: /\/(?s)[*].*?[*]\//

_END: "END"i

WS: /[ \t\f]+/
_NL: /[\r\n]+/

%ignore COMMENT
%ignore CCOMMENT
%ignore WS
