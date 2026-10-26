# n=5 model=out iset=I1 prefix14_class=1684
cmp P1, P0
cmovge S1, P1
cmovle S1, P0
cmovle P0, P1
cmp P3, P2
mov P1, P3
cmovle P3, P2
cmovge P1, P2
mov P2, P1
cmp P0, P2
cmovge P1, P0
mov S0, P3
cmovl P2, P0
mov P2, P1
