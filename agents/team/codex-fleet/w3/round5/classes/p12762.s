# n=5 model=out iset=I1 prefix14_class=12762
cmp P3, P0
mov S2, P1
cmovle S1, P0
cmovge S1, P3
cmovge P3, P0
cmp P2, P1
cmovl P1, P2
cmovl P2, S2
cmp P1, P3
cmovg P0, P3
mov S2, S1
cmovge P3, P1
cmovg P1, P0
cmp P2, S2
