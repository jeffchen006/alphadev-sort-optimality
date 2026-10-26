# n=5 model=out iset=I1 prefix14_class=6655
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmovg P0, S1
mov S2, P3
cmp P2, P3
cmovge P3, P2
cmovge P2, S2
mov S0, P3
cmp P3, P1
cmovg S0, P1
cmovl P3, P1
mov P3, P0
cmp P2, P3
