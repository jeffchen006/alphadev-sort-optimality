# n=5 model=out iset=I1 prefix14_class=4685
mov S0, P3
cmp P2, P3
cmovle P3, P2
cmovge S0, P2
cmp P0, P1
mov P2, P0
cmovge P0, P1
cmovl P2, P1
cmovge P1, P2
cmp P2, S0
cmovge P2, S0
cmovle P1, S0
cmp P0, P3
cmovle S1, P3
