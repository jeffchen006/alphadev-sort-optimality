# n=5 model=out iset=I1 prefix14_class=2916
cmp P0, P1
mov S0, P2
cmovle S1, P0
cmovge S1, P1
cmovge P1, P0
cmp P3, P2
cmovg P2, P3
cmovge P3, S0
mov S0, P1
cmp P2, S0
cmovle P1, P2
cmovl P2, S0
cmp S1, P3
mov P2, P1
