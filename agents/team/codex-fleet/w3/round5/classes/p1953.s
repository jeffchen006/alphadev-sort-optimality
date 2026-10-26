# n=5 model=out iset=I1 prefix14_class=1953
cmp P2, P3
cmovg S0, P3
cmovle S0, P2
cmovl P2, P3
mov S1, P0
cmp P1, S1
mov P3, P2
cmovle P0, P1
cmovge S1, P1
cmp S1, P3
cmovle P3, S1
cmovge P2, S1
cmp P0, S0
cmovge P1, S0
