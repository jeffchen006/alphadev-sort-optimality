# n=5 model=out iset=I1 prefix14_class=1097
mov S0, P3
cmp S0, P2
cmovle P3, P2
cmovle P2, S0
mov S0, P0
mov S2, P3
cmp P0, P1
cmovg P0, P1
cmovle S0, P1
cmp P3, S0
cmovl S2, S0
cmovl S0, P3
cmp P2, P0
mov P3, P0
