# n=5 model=out iset=I1 prefix14_class=13410
cmp P3, P2
mov S2, P2
cmovl S2, P3
mov S0, P1
cmovg P2, P3
cmp P0, S0
cmovg P1, P0
cmovle S0, P0
mov P3, S0
cmp S2, P3
cmovl P3, S2
cmovle S2, S0
cmovle P3, P2
cmp P2, P1
