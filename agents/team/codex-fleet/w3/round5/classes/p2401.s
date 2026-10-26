# n=5 model=out iset=I1 prefix14_class=2401
cmp P1, P2
cmovge S0, P1
cmovle S0, P2
cmovge P1, P2
cmp P3, P0
cmovge P2, P3
cmovl P2, P0
cmovle P0, P3
cmp P2, S0
cmovl P3, S0
cmovge P3, P2
cmovge P2, S0
mov P3, P1
cmovle S0, P2
