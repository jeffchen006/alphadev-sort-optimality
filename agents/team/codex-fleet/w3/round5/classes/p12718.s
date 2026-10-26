# n=5 model=out iset=I1 prefix14_class=12718
mov S1, P0
cmp P1, P2
mov S2, P1
cmovle S2, P2
cmovge P1, P2
cmp S1, P3
cmovle S1, P3
cmovl P3, P0
cmp P3, P1
cmovge P0, P1
cmovge P1, P3
cmovge P3, P0
mov S0, S1
cmp S1, S2
