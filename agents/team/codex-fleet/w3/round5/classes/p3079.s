# n=5 model=out iset=I1 prefix14_class=3079
cmp P1, P2
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
cmp P0, P3
mov S0, P3
cmovle S0, P0
cmovl P0, P3
mov P3, P0
cmp S0, P1
cmovge S2, S0
cmovg S0, P1
cmovg P1, S2
mov S0, P1
