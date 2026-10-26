# n=5 model=out iset=I1 prefix14_class=9097
mov S1, P3
mov S0, P2
cmp S0, P0
cmovge S0, P0
cmovle P2, P0
cmp S1, P1
cmovge S1, P1
cmovl P3, P1
cmovle P1, S1
cmp P1, S0
cmovle S1, S0
cmovle S0, P1
cmp P3, P2
cmovge P1, P2
