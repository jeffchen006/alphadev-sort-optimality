# n=5 model=out iset=I1 prefix14_class=8491
cmp P3, P1
cmovle S1, P3
cmovge S1, P1
cmovle P3, P1
cmp P0, P2
mov P1, P3
cmovle S0, P0
cmovl P0, P2
cmovle P2, S0
cmp P1, P0
cmovl P3, P0
mov P3, P2
cmovge P1, P0
cmp S1, P3
