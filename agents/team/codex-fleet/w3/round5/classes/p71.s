# n=5 model=out iset=I1 prefix14_class=71
cmp P3, P0
mov S1, P3
cmovl P3, P0
mov S0, P2
cmovg S1, P0
cmp P1, P2
cmovg P2, P1
cmovle S0, P1
cmp S0, S1
cmovge P1, S0
mov P0, P2
cmovge S0, S1
cmovge S1, P1
cmp P0, P3
