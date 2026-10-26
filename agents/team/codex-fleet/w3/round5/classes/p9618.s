# n=5 model=out iset=I1 prefix14_class=9618
mov S2, P2
cmp S2, P1
cmovg S2, P1
mov S0, P3
cmovge P1, P2
cmp S0, P0
cmovl P3, P0
cmovg S0, P0
cmp P3, P1
mov S1, P3
cmovg S1, P1
cmovg P1, P3
cmp S2, S0
mov P1, S0
