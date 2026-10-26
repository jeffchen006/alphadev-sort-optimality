# n=5 model=out iset=I1 prefix14_class=10982
mov S1, P0
cmp P0, P2
cmovge P0, P2
cmovge P2, S1
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovl P1, S1
cmp P3, P2
mov S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P0, P1
cmovle S0, P1
