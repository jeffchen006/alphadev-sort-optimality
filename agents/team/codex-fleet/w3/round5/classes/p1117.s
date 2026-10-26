# n=5 model=out iset=I1 prefix14_class=1117
cmp P3, P1
mov S2, P2
cmovle S0, P3
cmovle P3, P1
cmovle P1, S0
cmp P0, S2
cmovg S2, P0
mov S0, P3
cmovg P0, P2
cmp S0, S2
cmovl S0, S2
cmovle S2, P3
mov P3, P0
cmp P1, P3
