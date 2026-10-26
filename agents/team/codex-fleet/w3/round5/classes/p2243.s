# n=5 model=out iset=I1 prefix14_class=2243
mov S0, P1
cmp P2, S0
cmovg S0, P2
cmovg P2, P1
mov S2, P3
cmp P0, P3
cmovg S2, P0
cmovg P0, P3
mov P1, S2
cmp P1, S0
cmovl S2, S0
cmovle S0, P1
cmp P2, P0
cmovle P3, P2
