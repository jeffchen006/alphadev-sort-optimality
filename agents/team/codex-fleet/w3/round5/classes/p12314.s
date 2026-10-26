# n=5 model=out iset=I1 prefix14_class=12314
cmp P1, P2
cmovge S0, P2
cmovle S0, P1
cmovle P1, P2
mov P2, P0
cmp P3, P2
cmovl P2, P3
cmovge P0, P3
cmp P2, S0
cmovge P3, P2
cmovge P2, S0
cmovge S0, P3
mov P2, P0
cmp P2, P1
