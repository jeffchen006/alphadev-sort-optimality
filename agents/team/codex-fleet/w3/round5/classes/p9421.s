# n=5 model=out iset=I1 prefix14_class=9421
cmp P3, P2
mov S0, P0
cmovg S2, P2
cmovge P2, P3
cmovg P3, S2
cmp P1, S0
cmovl P0, P1
cmovl P1, S0
cmovle S0, P0
cmp P0, P3
cmovge P0, P3
cmovge P3, S0
cmp P2, P1
cmovl S2, P1
