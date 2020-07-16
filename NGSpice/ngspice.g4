grammar ngspice;

netlist
    : title include_instruction_list line_list END_KEYWORD (NEWLINE)* EOF 
    ;

include_instruction_list
    : include_instruction* 
	;

line_list 
    : line+
	;

title
    : identifier NEWLINE
    ;

identifier 
    : IDENTIFIER 
    | res_literal 
	| cap_lieral
	| inductor_literal
	| independent_voltage_source_literal 
	| independent_current_source_literal
	| voltage_controlled_voltage_source_literal
	| voltage_controlled_current_source_literal
	| current_controlled_voltage_source_literal
	| current_controlled_current_source_literal
	| diode_literal
	| bip_junction_transistor_literal
	| mosfet_literal
	| coupled_inductor_literal	
	;

line
    : element_statement
	| model_statement
	| subcurcuit 
    | analysis_command 
	| comment
	| NEWLINE
    ;

subcurcuit
	: subcircuit_title subcircuit_line+ ENDS_KEYWORD (identifier)? NEWLINE
	;
	
subcircuit_title 
    : SUBCIRCUIT_KEYWORD identifier (NumberLiteral)+ NEWLINE
    ;

subcircuit_line :
	 element_statement
	| model_statement
	| subcircuit_comment
	| NEWLINE
	;

subcircuit_comment
    : SUBCIRCUIT_COMMENT
	;

element_statement:
      resistor
	| capacitor
	| inductor
	| independent_voltage_source
	| independent_current_source
	| voltage_controlled_voltage_source
	| voltage_controlled_current_source
	| current_controlled_voltage_source
	| current_controlled_current_source
	| diode
	| bip_junction_transistor
	| mosfet
	| coupled_inductor
;

comment
    : COMMENT
	;

include_instruction 
    : INCLUDE_KEYWORD filename NEWLINE
	;
	
filename : StringLiteral;

resistor
    :  res_literal NumberLiteral NumberLiteral value NEWLINE
    ;
	
res_literal : RES;
	
capacitor
    :   cap_lieral capacitor_node1 capacitor_node2 value NEWLINE
    ;

cap_lieral : CAP;

inductor
    :  inductor_literal NumberLiteral NumberLiteral value NEWLINE
    ;
	
inductor_literal : INDUCTOR;
	
capacitor_node1 
    :    NumberLiteral | identifier
	;

capacitor_node2 
    :    NumberLiteral | identifier
	;
	
independent_voltage_source
    :   independent_voltage_source_literal NumberLiteral NumberLiteral VOLT_TYPE? (value|NumberLiteral) IND_VOLT_SOURCE? NEWLINE
	;
	
independent_voltage_source_literal 
    : IND_VOLT_SOURCE
	;
	
independent_current_source
    :   independent_current_source_literal NumberLiteral NumberLiteral VOLT_TYPE? (value|NumberLiteral) NEWLINE
	;
	
independent_current_source_literal
    :   IND_CUR_SOURCE
	;
	
voltage_controlled_voltage_source
    :   voltage_controlled_voltage_source_literal NumberLiteral NumberLiteral NumberLiteral NumberLiteral NumberLiteral NEWLINE
	;
	
voltage_controlled_voltage_source_literal
    :   VOLT_CONTROLLED_VOLT_SOURCE
	;
	
voltage_controlled_current_source
    :   voltage_controlled_current_source_literal NumberLiteral NumberLiteral LPAREN NumberLiteral COMMA NumberLiteral RPAREN value NEWLINE
	;
	
voltage_controlled_current_source_literal
    : VOLT_CONTROLLED_CUR_SOURCE
	;
	
current_controlled_voltage_source
    :   current_controlled_voltage_source_literal NumberLiteral NumberLiteral IND_VOLT_SOURCE value NEWLINE
	;
	
current_controlled_voltage_source_literal 
    : CUR_CONTROLLED_VOLT_SOURCE
	;
	
current_controlled_current_source
    :   current_controlled_current_source_literal NumberLiteral NumberLiteral IND_VOLT_SOURCE NumberLiteral NEWLINE
	;

current_controlled_current_source_literal
    : CUR_CONTROLLED_CUR_SOURCE
	;

diode
    :   diode_literal NumberLiteral NumberLiteral identifier NEWLINE
	;
	
diode_literal 
    : DIODE
    ;

bip_junction_transistor 
	: bip_junction_transistor_literal bip_list identifier NEWLINE
	;
	
bip_junction_transistor_literal
    : BIP_JUNCTION_TRANSISTOR
	;
	
bip_list : NumberLiteral NumberLiteral NumberLiteral;

mosfet  
    : mosfet_literal mosfet_list identifier (L_pair)? (W_pair)? NEWLINE
	;
	
mosfet_literal 
    : MOSFET
	;
	
L_pair : LETTER_L EQUAL (VALUE_WITH_POWER_OF_TEN | VALUE_WITHOUT_POWER_OF_TEN);

W_pair : LETTER_W EQUAL (VALUE_WITH_POWER_OF_TEN | VALUE_WITHOUT_POWER_OF_TEN);

mosfet_list : NumberLiteral NumberLiteral NumberLiteral NumberLiteral;
	
coupled_inductor : coupled_inductor_literal INDUCTOR INDUCTOR coupled_inductor_value;

coupled_inductor_literal
    : COUPLED_IND
    ;

coupled_inductor_value : value | NumberLiteral;

analysis_command
    : AC_KEYWORD AC_TYPE ac_list ( NEWLINE PROBE_KEYWORD )? NEWLINE
	;
	
/*dc_command
    : DC_KEYWORD */

ac_list : NumberLiteral NumberLiteral NumberLiteral;

model_statement   :  diode_model | bip_model | mos_model ;

diode_model : MODEL_KEYWORD identifier LETTER_D diode_param_list NEWLINE; 

bip_model : MODEL_KEYWORD identifier BIP_TRANSISTOR_TYPE bip_trans_param_list NEWLINE;

mos_model : MODEL_KEYWORD identifier MOS_TYPE mos_parameter_list NEWLINE;

diode_param_list 
	: LPAREN ( diode_param_pair )+ RPAREN 
	;
diode_param_pair
    : DIODE_SPECIFIC_PAIR | IS_PAIR
	;
	
bip_trans_param_list
    : LPAREN ( bip_trans_param_pair )+ RPAREN 
	;

bip_trans_param_pair 
    : BIP_SPECIFIC_PAIR | IS_PAIR
    ;

IS_PAIR : IS_PARAMETER EQUAL NumberLiteral; // is included in both diode and bip_transistor
DIODE_SPECIFIC_PAIR : DIODE_PARAM EQUAL NumberLiteral;
BIP_SPECIFIC_PAIR : BIP_PARAM EQUAL NumberLiteral;

mos_parameter_list
    : LPAREN ( mos_param_pair )+ RPAREN
	;

mos_param_pair : MOS_PARAM_PAIR;

MOS_PARAM_PAIR
    : MOS_PARAM EQUAL ( SIGN? NumberLiteral | SIGN? VALUE_WITH_POWER_OF_TEN | SIGN+ VALUE_WITHOUT_POWER_OF_TEN)
	;

BIP_TRANSISTOR_TYPE : 'npn' | 'pnp';

MOS_TYPE : 'nmos' | 'pmos';

IS_PARAMETER : 'IS';

AC_TYPE 
    : 'LIN'|'lin'|'DEC'|'dec'|'OCT'|'oct' 
    ;

DIODE_PARAM : 'XTI'|'N'|'BV'|'RS'|'CJO';
BIP_PARAM : 'BF'|'VA'|'BR';
MOS_PARAM : 'VTO'|'KP'|'LAMBDA';

VOLT_TYPE : 'DC'|'AC';

RES : [rR] (LetterOrDigitOrDelimiter)+;
INDUCTOR : [lL] (LetterOrDigitOrDelimiter)+;
CAP :   [cC] (LetterOrDigitOrDelimiter)+;
IND_VOLT_SOURCE: [vV] (LetterOrDigitOrDelimiter)+;
IND_CUR_SOURCE: [iI] (LetterOrDigitOrDelimiter)+;
VOLT_CONTROLLED_VOLT_SOURCE : [eE] (LetterOrDigitOrDelimiter)+;
VOLT_CONTROLLED_CUR_SOURCE : [gG] (LetterOrDigitOrDelimiter)+;
CUR_CONTROLLED_CUR_SOURCE : [fF] (LetterOrDigitOrDelimiter)+;
CUR_CONTROLLED_VOLT_SOURCE : [hH] (LetterOrDigitOrDelimiter)+;
DIODE : [dD] (LetterOrDigitOrDelimiter)+;
BIP_JUNCTION_TRANSISTOR : [qQ] (LetterOrDigitOrDelimiter)+;
MOSFET : [mM] (LetterOrDigitOrDelimiter)+;
COUPLED_IND : [kK] (LetterOrDigitOrDelimiter)+;

value   :   VALUE_WITH_POWER_OF_TEN | VALUE_WITHOUT_POWER_OF_TEN ;   // non-negative real

VALUE_WITH_POWER_OF_TEN   :   NumberLiteral POWER_OF_TEN (Letter)*;   
VALUE_WITHOUT_POWER_OF_TEN   :   NumberLiteral (Letter)+; 

POWER_OF_TEN : ('F'|'f')|('P'|'p')|('N'|'n')|('U'|'u')|('M'|'m')|('K'|'k')|('MEG'|'meg'|'X'|'x')|('G'|'g')|('T'|'t')|('MIL'|'mil') ;

fragment
DIG 
   : [0-9]
   ;

fragment NONZERODIGIT
   : [1-9]
   ;

NumberLiteral 
   : Floatingliteral | Integerliteral
   ;
	
Integerliteral :
    Decimalliteral ;
	
Decimalliteral
   : '0' | SIGN? NONZERODIGIT (DIG)*
   ;
	
Floatingliteral
   : Fractionalconstant ExponentPart? 
   | Digitsequence ExponentPart 
   ;

fragment Fractionalconstant
   : Digitsequence? '.' Digitsequence
   | Digitsequence '.'
   ;

fragment ExponentPart
   : 'e' SIGN? Digitsequence
   | 'E' SIGN? Digitsequence
   ;

fragment
SIGN :   [+-];

fragment Digitsequence : DIG+ ;

// Whitespace and comments

SUBCIRCUIT_COMMENT : ASTERISK (~[\r\n])* NEWLINE;
COMMENT :   PERCENT ( ~[\r\n] )* NEWLINE;
NEWLINE :   '\r'? '\n';
WS  :   (' '|'\t')+ -> channel(HIDDEN);

// Fragment rules
	
fragment Digits
    : [0-9] ([0-9_]* [0-9])?
    ;

fragment LetterOrDigit
    : Letter
    | [0-9]
    ;
	
fragment LetterOrDigitOrDelimiter
	: LetterOrDigit | [_-]
	; 

fragment Letter
    : [a-zA-Z_];


// Keywords

PROBE_KEYWORD   : '.probe';
END_KEYWORD   : '.end';
ENDS_KEYWORD   : '.ends';
MODEL_KEYWORD   : '.MODEL'|'.model';
SUBCIRCUIT_KEYWORD : '.SUBCKT'|'.subckt';
AC_KEYWORD : '.AC'|'.ac';
INCLUDE_KEYWORD: '.include';

// Separators

ASTERISK : '*';
EQUAL : '=';
COMMA: ',';
LPAREN : '(' ;
RPAREN : ')' ;
PERCENT:     '%'; // start of comment

LETTER_D : [dD];
LETTER_L : [lL];
LETTER_W : [wW];

IDENTIFIER : Letter LetterOrDigitOrDelimiter*;
//IDENTIFIER : [_]*[a-z][A-Za-z0-9_]* ;

StringLiteral 
   : ~[' '\t\r\n(),]+ 
   ;
