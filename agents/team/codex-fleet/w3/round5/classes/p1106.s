# n=5 model=out iset=I1 prefix14_class=1106
cmp P0, P2
mov S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P3, P1
cmovg S2, P3
mov S0, P0
cmovle S2, P1
cmovg P3, P1
cmp S0, S2
cmovle S0, S2
cmovle S2, P0
cmp P2, P3
cmovle S0, P3
