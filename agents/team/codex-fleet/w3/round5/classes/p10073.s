# n=5 model=out iset=I1 prefix14_class=10073
cmp P3, P0
cmovg S2, P0
cmovge P0, P3
cmovle S2, P3
cmp P1, P2
mov P3, P0
cmovge S0, P2
cmovg P2, P1
cmovge P1, S0
cmp P0, P2
cmovg P0, P2
cmovl P3, P2
mov P2, P1
cmp P1, S2
