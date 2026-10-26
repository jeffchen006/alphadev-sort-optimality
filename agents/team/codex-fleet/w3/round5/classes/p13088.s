# n=5 model=out iset=I1 prefix14_class=13088
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovg S2, P1
cmp P2, P0
cmovle P1, P2
cmovl P2, P0
cmovl P0, P1
mov S0, S2
cmp P0, S2
cmovg S0, P0
cmovl S2, P0
cmp P2, P3
mov P0, S0
