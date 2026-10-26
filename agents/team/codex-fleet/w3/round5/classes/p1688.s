# n=5 model=out iset=I1 prefix14_class=1688
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
cmovge S0, P0
cmp P2, P1
mov P0, P1
cmovl P0, P2
cmovl P2, P1
cmovle P1, P0
cmp P3, P0
cmovge P0, P3
cmovle P1, P3
mov P1, S0
cmovl P3, P0
