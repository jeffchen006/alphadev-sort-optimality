# n=5 model=out iset=I1 prefix14_class=521
mov S1, P0
cmp P0, P3
cmovge S1, P3
cmovg P3, P0
mov S0, P1
cmp S0, P2
cmovge P1, P2
cmovge P2, S0
mov S0, S1
cmp P1, S0
cmovg S0, P1
cmovle S1, P1
cmovl P1, S0
cmp P3, P2
