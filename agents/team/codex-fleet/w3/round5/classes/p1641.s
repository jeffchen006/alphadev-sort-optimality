# n=5 model=out iset=I1 prefix14_class=1641
cmp P2, P0
cmovge S1, P2
mov S0, P1
cmovge P2, P0
cmovl S1, P0
cmp P3, P1
cmovl P1, P3
cmovg S0, P3
mov S2, P2
cmp P2, P1
cmovle S2, P1
cmovge P2, P1
mov P2, S0
mov P1, S2
