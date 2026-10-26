# n=5 model=out iset=I1 prefix14_class=9635
cmp P2, P3
cmovg S1, P2
cmovle S1, P3
cmovge P2, P3
mov P3, P1
cmp P0, P1
cmovge P3, P0
cmovge P0, P1
cmovg P1, P3
cmp P3, S1
cmovl P1, S1
cmovg P3, S1
cmp P2, P0
cmovge P1, P2
