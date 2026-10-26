# n=5 model=out iset=I1 prefix14_class=12716
cmp P2, P1
mov S2, P2
cmovg P2, P1
mov S1, P0
cmovle S2, P1
cmp P0, P3
cmovl P0, P3
cmovl P3, S1
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovge P3, S1
cmp S2, P0
cmovl P1, S2
