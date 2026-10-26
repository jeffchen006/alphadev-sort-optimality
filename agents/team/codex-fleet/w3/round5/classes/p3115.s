# n=5 model=out iset=I1 prefix14_class=3115
mov S0, P1
cmp P3, P2
cmovle S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
cmovg S0, P0
cmovl P1, P0
mov P0, S1
cmp S1, P1
cmovle P0, P1
cmovge S1, P1
mov P1, S0
cmp P2, P1
