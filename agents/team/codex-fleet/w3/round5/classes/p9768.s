# n=5 model=out iset=I1 prefix14_class=9768
mov S0, P0
mov S2, P2
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmp P3, S2
cmovle S2, P3
cmovl P3, P2
cmp P1, P3
cmovg P0, P3
cmovge P3, P1
cmovg P1, P0
mov P3, P1
cmp S0, S2
