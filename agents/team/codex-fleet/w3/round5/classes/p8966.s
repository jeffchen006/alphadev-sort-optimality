# n=5 model=out iset=I1 prefix14_class=8966
mov S0, P1
cmp S0, P2
cmovle S0, P2
cmovle P2, P1
mov P1, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, P1
cmovl P1, P3
cmp S0, P3
cmovl P1, S0
cmovge P3, S0
cmp P2, P0
cmovge S0, P2
