# n=5 model=out iset=I1 prefix14_class=3912
mov S2, P1
cmp P1, P2
cmovge P1, P2
cmovge P2, S2
cmp P0, P3
cmovle S2, P0
cmovle P0, P3
cmovl P3, S2
cmp P1, P3
mov S0, P3
cmovle P3, P1
cmovge S0, P1
mov P3, P0
cmp P2, P0
