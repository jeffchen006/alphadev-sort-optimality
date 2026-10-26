# n=5 model=out iset=I1 prefix14_class=3825
cmp P1, P2
cmovle S2, P1
cmovg S2, P2
cmovg P2, P1
cmp P3, P0
cmovle P1, P0
cmovl P0, P3
cmovge P1, P3
cmp P0, S2
cmovl P3, S2
cmovl S2, P0
cmovge P3, P0
cmp P1, P2
cmovge P0, P1
