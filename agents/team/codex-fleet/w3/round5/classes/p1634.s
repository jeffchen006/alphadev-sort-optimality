# n=5 model=out iset=I1 prefix14_class=1634
mov S2, P1
mov S0, P2
cmp P2, P3
cmovle S0, P3
cmovge P2, P3
cmp P0, S2
cmovle S2, P0
cmovge P1, P0
cmp P2, S2
cmovge P3, S2
cmovl P3, P2
cmovle P2, S2
mov P3, S0
cmp S0, P1
