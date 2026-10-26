# n=5 model=out iset=I1 prefix14_class=13422
mov S1, P2
cmp P3, P0
mov S2, P3
cmovge P3, P0
cmovge P0, S2
cmp P1, S1
cmovle S1, P1
cmovge P2, P1
cmp P3, S1
cmovle P1, P3
cmovl P3, S1
cmovl S1, P1
cmp P0, P2
cmovl P1, P2
