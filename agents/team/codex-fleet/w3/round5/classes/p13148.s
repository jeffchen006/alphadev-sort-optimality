# n=5 model=out iset=I1 prefix14_class=13148
cmp P3, P1
mov S1, P1
mov S0, P2
cmovle S1, P3
cmovl P3, P1
cmp P2, P0
cmovl P2, P0
cmovg S0, P0
cmp S0, S1
cmovge P0, S0
cmovge S0, S1
cmovge S1, P0
cmp P3, P2
cmovl P1, P2
