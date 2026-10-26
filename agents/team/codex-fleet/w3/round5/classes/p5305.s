# n=5 model=out iset=I1 prefix14_class=5305
cmp P2, P1
mov S0, P0
cmovge S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
cmovle P0, P3
cmovg S0, P3
cmp S0, P2
mov S1, S0
cmovle S1, P2
cmovl P2, S0
mov S0, S1
cmp P1, P0
