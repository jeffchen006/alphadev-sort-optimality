# n=5 model=out iset=I1 prefix14_class=6621
cmp P3, P2
mov S0, P2
cmovg P2, P3
cmovle S0, P3
cmp P0, P1
mov P3, P0
cmovge P3, P1
cmovl P0, P1
mov P1, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, P1
cmp P3, S0
cmovge P1, P3
