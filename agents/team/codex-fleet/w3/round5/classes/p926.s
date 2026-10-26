# n=5 model=out iset=I1 prefix14_class=926
mov S2, P1
cmp P2, S2
mov S0, P0
cmovg S2, P2
cmovl P1, P2
cmp S0, P3
cmovge S0, P3
cmovg P3, P0
mov P0, S2
mov P2, P1
cmp P3, P0
cmovge P0, P3
cmovg P3, S2
mov S2, P3
