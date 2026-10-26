# n=5 model=out iset=I1 prefix14_class=5164
mov S1, P0
cmp P0, P3
mov S2, P2
cmovl P0, P3
cmovl P3, S1
cmp P1, S2
cmovle S2, P1
cmovl P1, P2
cmp S2, P3
cmovge S1, S2
cmovge S2, P3
mov S2, P0
cmovge P3, S1
cmp P1, P0
