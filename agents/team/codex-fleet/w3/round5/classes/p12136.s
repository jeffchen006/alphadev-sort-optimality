# n=5 model=out iset=I1 prefix14_class=12136
cmp P3, P0
mov S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P1, P2
cmovge S1, P1
mov S0, P3
cmovge P1, P2
cmovg P2, S1
cmp P1, S0
cmovg S0, P1
cmovl P3, P1
mov P3, P2
cmp P3, P0
