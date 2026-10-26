# n=5 model=out iset=I1 prefix14_class=12839
mov S2, P2
cmp P1, P2
cmovg P2, P1
cmovg P1, S2
mov S1, P3
cmp P0, S1
cmovl S1, P0
cmovg P3, P0
cmp P1, S1
cmovle S0, S1
cmovl S1, P1
cmovl P1, S0
mov S1, P2
mov S2, P1
