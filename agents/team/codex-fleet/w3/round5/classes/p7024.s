# n=5 model=out iset=I1 prefix14_class=7024
mov S0, P1
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, S2
cmp P1, P0
cmovg P1, P0
mov S2, P1
cmovle S0, P0
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmp P2, S0
cmovl P0, S0
