# n=5 model=out iset=I1 prefix14_class=11736
mov S0, P2
cmp P1, S0
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
mov P1, P2
cmovge S1, P0
cmovge P0, P3
cmovge P3, S1
cmp P1, P3
cmovle P2, P3
cmovle P3, P1
cmp P0, S0
cmovl S1, P0
