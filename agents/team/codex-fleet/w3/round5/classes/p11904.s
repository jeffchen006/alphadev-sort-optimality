# n=5 model=out iset=I1 prefix14_class=11904
cmp P0, P3
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
mov S0, P1
cmovle P2, S2
cmp S0, P0
cmovge S0, P0
cmovg P0, P1
cmp P3, P2
cmovge S1, P2
