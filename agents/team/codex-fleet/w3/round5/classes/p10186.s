# n=5 model=out iset=I1 prefix14_class=10186
cmp P1, P0
mov S1, P1
cmovge P1, P0
cmovge P0, S1
cmp P2, P3
cmovge S1, P2
cmovg P2, P3
cmovg P3, S1
mov S0, P0
cmp P3, S0
cmovg S0, P3
cmovl P0, P3
mov S0, P0
cmp P1, P2
