# n=5 model=out iset=I1 prefix14_class=10464
cmp P0, P3
mov S1, P0
cmovg P0, P3
cmovg P3, S1
mov S1, P1
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmp P3, S1
cmovge P1, S1
cmovg S1, P3
cmovl P1, P3
cmp P0, P2
cmovge S1, P2
