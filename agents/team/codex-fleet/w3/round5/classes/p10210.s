# n=5 model=out iset=I1 prefix14_class=10210
cmp P0, P3
mov S1, P2
cmovge S0, P3
cmovl S0, P0
cmovge P3, P0
cmp P1, S1
cmovle P2, P1
cmovg S1, P1
cmp P3, S1
mov S2, S1
cmovl S1, P3
cmovge S2, P3
cmp S0, P2
cmovle S2, S0
