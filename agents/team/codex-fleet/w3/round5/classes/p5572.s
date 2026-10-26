# n=5 model=out iset=I1 prefix14_class=5572
mov S1, P1
cmp P3, S1
mov S0, P0
cmovge P1, P3
cmovge P3, S1
cmp P0, P2
cmovle P0, P2
mov S2, P3
cmovl P2, S0
cmp P2, S2
cmovle P3, P2
cmovg S2, P2
cmp P1, P0
cmovl S0, P1
