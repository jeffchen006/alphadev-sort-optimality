# n=5 model=out iset=I1 prefix14_class=11418
mov S0, P1
cmp P0, S0
cmovle S0, P0
cmovl P0, P1
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovg P3, S2
mov P1, S0
cmp S0, P2
cmovl P1, P2
cmovg S0, P2
mov S0, P3
cmp S0, P0
