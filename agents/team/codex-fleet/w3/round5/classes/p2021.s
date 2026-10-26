# n=5 model=out iset=I1 prefix14_class=2021
cmp P2, P3
cmovg S1, P3
cmovg P3, P2
cmovg P2, S1
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovg S2, P0
mov P0, P1
cmp P3, P0
cmovg P1, P3
cmovg P3, P0
cmp P2, S2
cmovl S0, S2
